Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZJVPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZJVPH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbZJVPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZJVPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:07:56 -0400
Message-ID: <4AE07541.8060903@redhat.com>
Date: Thu, 22 Oct 2009 17:07:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com> <4ADF2A1B.3010205@gmail.com> <20091021153640.GS29477@redhat.com> <4ADF2BDD.40706@gmail.com>
In-Reply-To: <4ADF2BDD.40706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2009 05:42 PM, Gregory Haskins wrote:
> I believe Avi, Michael, et. al. were in agreement with me on that design
> choice.  I believe the reason is that there is no good way to do EOI/ACK
> feedback within the constraints of an eventfd pipe which would be
> required for the legacy pin-type interrupts.  Therefore, we won't even
> bother trying.  High-performance subsystems will use irqfd/msi, and
> legacy emulation can use the existing injection code (which includes the
> necessary feedback for ack/eoi).
>
>    

Right.  But we don't actually prevent anyone using non-msi with irqfd, 
which can trigger the bad lock usage from irq context, with a nice boom 
afterwards.  So we need to either prevent it during registration, or to 
gracefully handle it afterwards.

-- 
error compiling committee.c: too many arguments to function

