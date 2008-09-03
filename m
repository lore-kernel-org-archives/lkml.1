Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYICXu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYICXu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYICXuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:50:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYICXuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:50:11 -0400
Date: Wed, 3 Sep 2008 16:50:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Finding what is stuck...
Message-ID: <20080903165014.134cb5b9@infradead.org>
In-Reply-To: <20080904010043.408b3f03@one.home>
References: <20080902020447.5b48b083@one.home>
	<20080901170812.2c3b041b@infradead.org>
	<20080904010043.408b3f03@one.home>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 01:00:43 +0200
"J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 1 Sep 2008 17:08:12 -0700, Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > On Tue, 2 Sep 2008 02:04:47 +0200
> > "J.A. Magallón" <jamagallon@ono.com> wrote:
> > 
> > > Hi all...
> > > 
> > > I'm running 2.6.27-rc5-git2 on an Aspire One.
> > > The system is in general pretty responsive, but sometimes it just
> > > gets totally stuck. Even the mouse stops. 
> > > 
> > > It looks related to disk (SSD) access, but I'm not totally sure.
> > > Is there any way to find what is getting stuck ? I know that SSDs
> > > can be slow on write, I don't mind if the system is faster or
> > > slower (it's small :))), but if the speed is constant. That
> > > occasional pauses are strange, like if SSD flushing gets stuck on
> > > BKL (I know, no idea about what I talk...).
> > > 
> > > I'm using ext3 fs, noop iosched. But as I say, I'm not sure that
> > > the disk writes are the culprit.
> > > 
> > > Any idea about how to find this ?
> > 
> > Have you tried to run "latencytop"?
> > (you need to enable this in the kernel config as well)
> > 
> > it tends to (for me at least) point out very well where stalls
> > happen, or at least, what the system is doing when they happen.
> > 
> > (hint: make sure you do "make install" before running it)
> > 
> 
> These are some shots of latencytop while working. I copied the screen
> when I saw any very high timing...
> 

wow bad ones..

one thing to note.. you have *something* doing fsync() a lot it seems
(latencytop is likely to tell you which one it is); fsync on ext3 is
really expensive, especially on an ssd that is slow to write to.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
