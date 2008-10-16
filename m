Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYJPSU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYJPSU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYJPSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:20:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:57242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYJPSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:20:20 -0400
Message-ID: <48F785B0.7000008@kernel.org>
Date: Thu, 16 Oct 2008 11:19:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: n0ano@n0ano.com
CC: Paul Bolle <pebolle@tiscali.nl>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com>
In-Reply-To: <20081016171218.GD14490@xolotl.n0ano.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n0ano@n0ano.com wrote:
> On Thu, Oct 16, 2008 at 09:23:39AM -0700, Yinghai Lu wrote:
>> ... 
>> earlycon= and conole= share uart[8250]...
>>
>> the difference console= will start from early console and switch normal console automatically if the ttyS come out with same io/mmio address etc.
>>
> 
> But there is no advantage to `earlycon' given that you can accomplish
> the same thing with `console'.  The only use that I can see is if
> you specify `earlycon' without specifying `console' and then all
> you get are the initial kernel messages, after the serial drivers
> intializes all further messages go to the VGA.  If makes much more
> sense to me to just use the `console' parameter to get all kernel
> messages on the serial port, and then there is no need for
> `earlycon'.
> 


/* Check for early params. */
static int __init do_early_param(char *param, char *val)
{
        struct obs_kernel_param *p;

        for (p = __setup_start; p < __setup_end; p++) {
                if ((p->early && strcmp(param, p->str) == 0) ||
                    (strcmp(param, "console") == 0 &&
                     strcmp(p->str, "earlycon") == 0)
                ) {
                        if (p->setup_func(val) != 0)
                                printk(KERN_WARNING
                                       "Malformed early option '%s'\n", param);
                }
        }
        /* We accept everything at this stage. */
        return 0;
}

we need that holder in console sections to compare with console and earlycon.

YH
