Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYHESI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYHESI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbYHESIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:08:19 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:37162 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756137AbYHESIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:08:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S8/8D5DgRcX6pKdwpIV+XaM1dtkWD78yXxc4453jZ1M7mBQGH9eFGihacwQ+JGurTvgLZU0Tc2PTz4sevXxwb+/m5ETWpqoa1/cmNiZgDjvqaf2MYG3B0koOVzhR8Oyik6JQAADLbG+LGHDhueGwI54vTO3AhJ7h42TvZIDCfLA=  ;
X-YMail-OSG: fzejbjQVM1mWKybmsqj5lOen47Z_MXJT2_PWfgkkLqpZYJifX8FQEMT5EB162DuIfDJu6ZQuV_QwO4.wGAOHYmq00AuzFm.K1Qbtq.9Z.FGr8A5Qo7L28zHmMZ2Az1OoBZU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Date: Wed, 6 Aug 2008 04:08:05 +1000
User-Agent: KMail/1.9.5
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
References: <1217883616.27684.19.camel@localhost.localdomain>
In-Reply-To: <1217883616.27684.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060408.05272.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 07:00, Eric Paris wrote:
> Please contact me privately or (preferably the list) for questions,
> comments, discussions, flames, names, or anything.  I'll do complete
> rewrites of the patches if someone tells me how they don't meet their
> needs or how they can be done better.  I'm here to try to bridge the
> needs (and wants) of the anti-malware vendors with the technical
> realities of the kernel.  So everyone feel free to throw in your two
> cents and I'll try to reconcile it all.  These 5 patches are part 1.
> They give us a working able solution.
>
> >From my point of view patches forthcoming and mentioned below should
>
> help with performance for those who actually have userspace scanners but
> also could presents be implemented using this framework.
>
>
> Background
> ++++++++++
> There is a consensus in the security industry that protecting against
> malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
> of so-called on-access scanning is usable and reasonable approach.
> Currently the Linux kernel does not offer a completely suitable
> interface to implement such security solutions.  Present solutions
> involve overwriting function pointers in the LSM, in filesystem
> operations, in the sycall table, and other fragile hacks.  The purpose
> of this project is to create a fast, clean interface for userspace
> programs to look for malware when files are accessed.  This malware may
> be ultimately intended for this or some other Linux machine or may be
> malware intended to attack a host running a different operating system
> and is merely in transit across the Linux server.  Since there are
> almost an infinite number of ways in which information can enter and
> exit a server it is not seen as reasonable to move these checks to all
> the applications at the boundary (MTA, NFS, CIFS, SSH, rsync, et al.) to
> look for such malware on at the border.
>
> For this Linux kernel interface speed is of particular interest for
> those who have it compiled into the kernel but have no userspace client.
> There must be no measurable performance hit to just compiling this into
> the kernel.
>
> Security vendors, Linux distributors and other interested parties have
> come together on the malware-list mailing list to discuss this problem
> and see if they can work together to propose a solution. During these
> talks couple of requirement sets were posted with the aim of fleshing
> out common needs as a prerequisite of creating an interface prototype.
>
> Collated requirements
> +++++++++++++++++++++

I suspect that what people actually want is a requirement of what it is
they are trying to do. Not a list of demands on the kernel that they think
are needed to implement what they think is the right way to solve some
problem that they define.


> 5. Define which filesystems are cacheable and which are not

This is practically impossible to do completely without rewriting a lot
of code (which will never be accepted). I don't see why it is needed though
as the filesystem cache is supposed to be kept coherent with disk.
