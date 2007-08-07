Return-Path: <linux-kernel-owner+w=401wt.eu-S934591AbXHGNiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbXHGNiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762518AbXHGNhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:37:54 -0400
Received: from mailout03.sul.t-online.de ([194.25.134.81]:57793 "EHLO
	mailout03.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbXHGNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:37:53 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 09:37:53 EDT
Message-ID: <46B87590.60208@t-online.de>
Date: Tue, 07 Aug 2007 15:37:20 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070804)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
References: <23249.1186492623@redhat.com> <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com> <23350.1186492903@redhat.com>
In-Reply-To: <23350.1186492903@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: EPT68cZvoeNPVdGzj+L916eMG28c3z91A1cWFMLYgKiFLm6us0di65
X-TOI-MSGID: 5f4b97b9-e615-4559-bf2b-c3dafafdc21a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:

> +	/* we allocated a power-of-2 sized page set, so we need to trim off the
> +	 * excess */
> +	total = 1 << order;
> +	atomic_add(total, &mmap_pages_allocated);
> +
> +	point = len >> PAGE_SHIFT;
> +	while (point < total) {
> +		order = ilog2(total - point);
> +		_debug("shave %u/%lu", 1 << order, total - point);
> +		atomic_sub(1 << order, &mmap_pages_allocated);
> +		__free_pages(pages + point, order);
> +		point += 1 << order;
> +	}

Note that we've had a similar change in our kernel, and we've had to
revert it since the effect on fragmentation is just horrendous.  Without
this, we could run a complete gcc testsuite on the board; with it we'd
run out of high-order pages somewhere in the middle.

This probably wants to be dependent on something like MAP_TRIM_EXCESS.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
