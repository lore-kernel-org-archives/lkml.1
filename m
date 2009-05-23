Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZEWVFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZEWVFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZEWVF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:05:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:58368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZEWVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:05:26 -0400
Date: Sat, 23 May 2009 14:05:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Larry H." <research@subreption.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu
Subject: Re: [PATCH] Support for unconditional page sanitization
Message-ID: <20090523140509.5b4a59e4@infradead.org>
In-Reply-To: <20090523182141.GK13971@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090522143914.2019dd47@lxorguk.ukuu.org.uk>
	<20090522180351.GC13971@oblivion.subreption.com>
	<20090522192158.28fe412e@lxorguk.ukuu.org.uk>
	<20090522234031.GH13971@oblivion.subreption.com>
	<20090523090910.3d6c2e85@lxorguk.ukuu.org.uk>
	<20090523085653.0ad217f8@infradead.org>
	<20090523182141.GK13971@oblivion.subreption.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 May 2009 11:21:41 -0700
"Larry H." <research@subreption.com> wrote:

> +static inline void sanitize_highpage(struct page *page)

any reason we're not reusing clear_highpage() for this?
(I know it's currently slightly different, but that is fixable)


also, have you checked that you stopped clearing the page in the
normal anonymous memory pagefault handler path? If the page is 
guaranteed to be clear already you can save that copy
(basically you move the clear from allocate to free..)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
