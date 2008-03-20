Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYCTSjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYCTSjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYCTSjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:39:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49023 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542AbYCTSjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:39:31 -0400
Date: Fri, 21 Mar 2008 00:12:16 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: skumar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Poornima Nayak <Poornima.Nayak@in.ibm.com>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [BUG]2.6.25-rc6:Unable to handle kernel paging request
Message-ID: <20080320184216.GB32259@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
References: <20080318052921.GA32259@in.ibm.com> <18400.36670.5918.566965@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18400.36670.5918.566965@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:57:50PM +1100, Paul Mackerras wrote:
> Sudhir Kumar writes:
> 
> > Unable to handle kernel paging request for data at address
> > 0xd00008000000002e
> 
> Looks like some driver tried to access I/O port 0x2e without checking
> whether there was possibly anything there first.
> 
> > Faulting instruction address: 0xc00000000074ded8
> > cpu 0x0: Vector: 300 (Data Access) at [c00000003e073aa0]
> >     pc: c00000000074ded8: .f71805f_find+0x44/0x32c
> >     lr: c00000000074e1f8: .f71805f_init+0x38/0x194
> >     sp: c00000003e073d20
> >    msr: 8000000000009032
> >    dar: d00008000000002e
> >  dsisr: 42000000
> >   current = 0xc0000000220851c0
> >   paca    = 0xc0000000007c2700
> >     pid   = 1, comm = swapper
> > enter ? for help
> > [c00000003e073dc0] c00000000074e1f8 .f71805f_init+0x38/0x194
> 
> Looks like it might be the f71805f driver, whatever that is...
> Hmmm, drivers/hwmon/f71805f.c looks like it, and indeed it does go
> poking around in PCI I/O space with no checks whatever.
> 
> I suggest you turn off CONFIG_SENSORS_F71805F.
It was a new feature so I turned it on while compiling.
I have tried by turning off CONFIG_SENSORS_F71805F but the bug
is still present.
> 
> It doesn't help, of course, that CONFIG_HWMON defaults to y. :(
> 
> Paul.
Thanks
Sudhir Kumar
ISTL IBM
