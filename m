Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYHRTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYHRTIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762827AbYHRTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:05:22 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37742 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762817AbYHRTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:05:19 -0400
Message-ID: <48A9C5C0.5010705@freescale.com>
Date: Mon, 18 Aug 2008 13:56:00 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>	<48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>	<48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181445160.796@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808181445160.796@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> What syntax to do that with?
> 
>   lwz %1,0(%U2)
>   stu %3, 0(%X2)
> 
> I'm new to those. (and the above does not compile)

lwz%U2%X2 %1, %2
stw%U2%X2 %3, %2

>> Why stwu with an offset of zero,
> 
> How else to do it?  stwu %3, (%2) does not compile for me.

stw %3, 0(%2)

The "u" tells it to write the effective address back to %2 -- but with 
an offset of zero, the effective address is unchanged.

-Scott
