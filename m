Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFBWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFBWk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZFBWkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:40:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZFBWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:40:50 -0400
Date: Tue, 2 Jun 2009 18:40:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: George Dunlap <george.dunlap@eu.citrix.com>
Cc: David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
Message-ID: <20090602224051.GB32428@goodmis.org>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1FCE8E.2060604@eu.citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 01:01:18PM +0100, George Dunlap wrote:
>
> If we take him at his word, that the root issue is that he fundamentally  
> dislikes the design choice of running Linux-as-hypervisor-component,  
> then we have a difference of opinion and we're just going to have to  
> agree to disagree.  But there are reasons to include it anyway,  
> including benefits to existing Xen users and potential Xen users (who  
> have decided not to use KVM for whatever reason), and the idea of  
> survival-of-the-fittest: Xen and KVM have made different design choices,  
> let's let them both grow and see which one thrives.  If KVM's design is  
> unilaterally superior, eventually Xen will die off.  But I suspect that  
> there's significant demand in the OSS virtualization ecology for both  
> approaches, and the world will be the worse for dom0 support being  
> out-of-tree.
>

Three years ago, when I was hired by Red Hat, I was put on the Virt team,
and I had to work on Xen. I found it an awkward community to say the least.
But I'll refrain from talking about that experience.

Before I was hired, I was full time developing the -rt patch. I was accustom
to the way the Linux development worked, and felt comfortable with it. I was
very pleased when I left the virt team to go back to work on the -rt patch.
Just before I left, KVM came out. I started playing with it and I once again
felt comfortable in that development. I probably would not have mind working
in the virt team if it was KVM that I was working on. I guess the point I'm
trying to make here is that KVM is developed in a Linux community, Xen is not.

The major difference between KVM and Xen is that KVM _is_ part of Linux. Xen
is not. The reason that this matters is that if we need to make a change to
the way Linux works we can simply make KVM handle the change. That is, you
could think of it as Dom0 and the hypervisor would always be in sync.

If we were to break an interface with Dom0 for Xen then we would have a bunch
of people crying foul about us breaking a defined API. One of Thomas's complaints
(and a valid one) is that once Linux supports an external API it must always
keep it compatible. This will hamper new development in Linux if the APIs are
scattered throughout the kernel without much thought.

Now here's a crazy solution. Merge the Xen hypervisor into Linux ;-)

Give full ownership of Xen to the Linux community. One of your people could be
a maintainer. This way the API between Dom0 and the hypervisor would be an internal
one. If you needed to upgrade Dom0, you also must upgrade the hypervisor, but that
would be fine since the hypervisor would also be in the Kernel proper.

This may not solve all the issues that the x86 maintainers have with the Dom0
patches, but it may help solve the API one.

Yeah, I know, I'll be having snowball fights with Saddam before that happens.

-- Steve

