Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYCaPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYCaPZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYCaPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:25:34 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:8960 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYCaPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o7kYeI9yg9HBe441rbRpVg1RF0ON57w0+rzCC6sgmKHfBlMILsXX/s0lox93Aps+HvgSc8PV2AtKg70YVgvokR7T1UnOqSpmVgjbhriko944f10ViKrWFjDRCa9bWdcV006aLp5bzE6sSSyuw5TeshV2aPPCNJYl7MsdIMQI03Q=
Message-ID: <3e8340490803310825r407f792fv9158c0a9ee7cda93@mail.gmail.com>
Date: Mon, 31 Mar 2008 11:25:32 -0400
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Eric Descourtis" <desc0068@algonquincollege.com>
Subject: Re: Limiting CPU usage for processes in linux 2.6.18.8
Cc: linux-kernel@vger.kernel.org, eric.des.courtis@gmail.com
In-Reply-To: <fbb49c58d56e.47f0403c@algonquincollege.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbb49c58d56e.47f0403c@algonquincollege.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 9:37 PM, Eric Descourtis
<desc0068@algonquincollege.com> wrote:
> Hello,
>
>  I would like to implement a patch to the scheduler that limits the CPU usage of individual
>  processes to a percentage in Linux 2.6.18.8 (Can't be any other version).
>  I would just like some feedback on the following questions:
>
>  1. How can I ensure that limited processes get their CPU time percentage allocation?
>  2. Are there mechanisms in place that would simplify this process?
>
>  I have been hitting my head against the wall for a long time now, any help would be appreciated.

The scheduler isn't really designed to force programs to idle when
there's nothing else to run - that would be a waste :)

If the reason you're on 2.6.18.8 is for Xen, you might want to try
using a recent kernel with paravirt ops, and use the CFS fair group
(or user) scheduler to set cpu shares. See
Documentation/sched-design-CFS.txt . If you really want to eat up a
certain portion of CPU time doing nothing, you could create a program
to busy-loop to starve the others and set CPU shares appropriately,
though I don't really see the point in that.
