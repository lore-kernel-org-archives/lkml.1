Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZDKHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZDKHf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZDKHfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:35:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:27706 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZDKHfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SoDDMnX6D2c41tw9za/+IC3YRgO9C+/ulhYYo4ExAtBsHm5lnhUK8aZ5ONIpPRGMcL
         eoI/6JIBJtJBpdr+cRikr9zAxszcwLCyb1vwHKcq9bp8Iqr9sIO49OJ9q9x5kHxwuEyF
         9URy1fvnvNHDvymyE0cErdu0p1PFxClo3AW1Q=
MIME-Version: 1.0
In-Reply-To: <20090410213943.GB7242@us.ibm.com>
References: <20090408210745.GE11159@us.ibm.com>
	 <86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com>
	 <20090410213943.GB7242@us.ibm.com>
Date: Sat, 11 Apr 2009 00:35:09 -0700
Message-ID: <86802c440904110035m4cec46f5n5ab7d43e00f42d9f@mail.gmail.com>
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered 
	active device IRQ interrruption
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:39 PM, Gary Hade <garyhade@us.ibm.com> wrote:

> move_masked_irq() clears the IRQ_MOVE_PENDING desc->status
> bit before calling the function pointed to by
> desc->chip->set_affinity [e.g. set_ioapic_affinity_irq()]
> AND the content of desc->pending_mask is not used after
>  cpumask_and(desc->affinity, desc->pending_mask, cpu_online_mask);
> which precedes the set_affinity function call.  So, I believe
> this provides the necessary separation between the
> IRQ_MOVE_PENDING/desc->pending_mask useage in move_masked_irq()
> and the IRQ_MOVE_PENDING/desc->pending_mask useage in the code
> that the patch adds.
>
that should be ok, they are proteced by spin_lock(&desc->lock)

YH
