Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbYD1LoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbYD1LoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbYD1LoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:44:14 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:22693
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763223AbYD1LoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:44:14 -0400
Message-ID: <4815B88B.3010909@qumranet.com>
Date: Mon, 28 Apr 2008 14:44:11 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Izik Eidus <izike@qumranet.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: kvm: how big is type?
References: <1209323919.14173.73.camel@brick>
In-Reply-To: <1209323919.14173.73.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> arch/x86/kvm/x86.c:3484:25: warning: cast truncates bits from constant value (100 becomes 0)
> arch/x86/kvm/x86.c:3510:24: warning: cast truncates bits from constant value (100 becomes 0)
>
> The problem:
> 		cseg_desc.type &= ~(1 << 8); //clear the B flag
> 		nseg_desc.type |= (1 << 8);
>
> type is a 4-bit bitfield on x86....please look into this.
>
>   

I think it ought to be (1 << 1), not (1 << 8), as it refers to the 
"busy" bit of the task type.  Izik?


-- 
error compiling committee.c: too many arguments to function

