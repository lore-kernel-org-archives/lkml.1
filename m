Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYBNPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYBNPUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYBNPUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:20:03 -0500
Received: from www.tglx.de ([62.245.132.106]:47017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbYBNPT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:19:59 -0500
Date: Thu, 14 Feb 2008 16:19:42 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
Message-ID: <20080214161942.55ce5089@dilbert.local>
In-Reply-To: <Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
References: <20080214093051.7240852AB0E31@trashmail.net>
	<1202981957.10928.17.camel@phobos.jasper.bg>
	<p73pruz27mk.fsf@bingen.suse.de>
	<Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 14 Feb 2008 16:00:06 +0100 (CET)
schrieb Jan Engelhardt <jengelh@computergmbh.de>:

> 
> On Feb 14 2008 10:46, Andi Kleen wrote:
> >Jasper Bryant-Greene <jasper@unix.geek.nz> writes:
> >>
> >> This could be done fairly trivially with FUSE, and IMHO is a good
> >> use for FUSE because since you're just throwing most data away,
> >> performance is not a concern.
> 
> There is a much more interesting 'problem' with a "/dev/null
> directory".
> 
> Q: Why would you need such a directory?
> A: To temporarily fool a program into believing it wrote something.
> 
> Q: Should all files disappear? (e.g. "unlink after open")
> A: Maybe not, programs may stat() the file right afterwards and
>    get confused by the "inexistence".
> 
> Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
>    create a file /dev/nullmnt/foo/barfile?
> A: /dev/nullmnt/foo must continue to exist or be accepted for a while,
>    or perhaps for eternity.

Well, the problem seems to be that a "directory" is not just data but
also contains metadata. While it's easy to write data to /dev/null, you
cannot simply discard metadata associated with a directory. So, such a
"/dev/null-directory" would have to remember metadata (at least all
created filenames including subdirectories) in the same way as other
filesystems do. Only file _content_ can be discarded.
To be honest, I still cannot see many sensible usecases for that...

Thanks,
Hans
 
