Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYKPQGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYKPQGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKPQF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:05:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:57624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYKPQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:05:59 -0500
Date: Sun, 16 Nov 2008 08:06:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116080641.3f4c3dba@infradead.org>
In-Reply-To: <20081116165609.4f17fc10@kopernikus.site>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116073948.02aea58c@infradead.org>
	<20081116165609.4f17fc10@kopernikus.site>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 16:56:09 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> > > While the original submission of CONFIG_STRICT_DEVMEM mentions
> > > that the option has been in RHEL and Fedora for 4 years without
> > > problems, that's only a half of the story. The truth is that at
> > > least RHEL has /dev/crash exactly to circumvent that /dev/mem
> > > restriction. Don't tell me that this is better than having that
> > > sysctl entry. ;-)
> > 
> > I assume /dev/crash is read only
> 
> I don't know. But if that matters, why can't we make /dev/mem
> write-only for certain areas and read-only for the rest ...?
> 
> > You either want this at compile time or you don't want it at all.
> 
> Why? You don't write something about my arguments (as Alan does, even
> though I disagree), you only write that you "nak" it.

It's very simple: if you want the strict form you really want the
strict form, not some half "oh but it's one line to turn off" form.


(Note: your usecase is in trouble in general already with PAT used by
modern video drivers: the requirement is that all mappings of the same
physical page are mapped with the same cachability semantics. mmaping
random parts of physical real memory via /dev/mem makes that a way too
complex issue and will likely turn the crash utility in what it's name
says ;-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
