Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJWBJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJWBJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZJWBJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:09:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:58953 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZJWBJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ic096U9Ff+4RbliutfMdGRG5TdwQzjqfZBd/v509t+nF01hQTBFVs7VLn1WZ16C7o+
         RyCoAvazgNlXn5jw/4JYgikD5lOQqCYdZTHMkeOZptS1TEX21ZN+uEW8Pi0Nh4voLCzH
         6jzk1HlNMRmaM9KNo4BDq0/gwJ3dsDqBLejdE=
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: Adam Nemet <anemet@caviumnetworks.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256248517.20866.806.camel@gandalf.stny.rr.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon> <4AE0A5BE.8000601@caviumnetworks.com>
	 <19168.49354.525249.654494@ropi.home>
	 <1256244726.20866.802.camel@gandalf.stny.rr.com>
	 <19168.52948.22223.757259@ropi.home>
	 <1256248517.20866.806.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 23 Oct 2009 09:09:06 +0800
Message-Id: <1256260146.6381.4.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 17:55 -0400, Steven Rostedt wrote:
> On Thu, 2009-10-22 at 14:29 -0700, Adam Nemet wrote:
> > Steven Rostedt writes:
> > > On Thu, 2009-10-22 at 13:30 -0700, Adam Nemet wrote:
> > > > Also note that for functions invoked via tail call you won't get an exit
> > > > event.  E.g. if bar is tail-called from foo:
> > > > 
> > > >   foo entered
> > > >   bar entered
> > > >   foo/bar exited
> > > > 
> > > > However, this is not MIPS-specific and you can always disable tail calls
> > > > with -fno-optimize-sibling-calls.
> > > 
> > > The question is, would bar have a _mcount call? So far, we have not had
> > > any issues with this on either x86 nor PPC.
> > 
> > Yes, bar will have an _mcount call.  The difference is that bar will return to
> > foo's caller directly rather than to foo first.
> 
> I guess the best bet is to have CONFIG_FUNCTION_GRAPH enable
> -fno-optimize-sibling-calls and be done with it.
> 

Hello, This did for us:

Makefile:

ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
KBUILD_CFLAGS   += -fomit-frame-pointer
endif

So, the only thing we need to do is enabling CONFIG_FRAME_POINTER.
Seems it was selected by FTRACE by default.

Regards,
	Wu Zhangjin

