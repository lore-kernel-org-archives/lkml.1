Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZFEQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZFEQ1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZFEQ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:27:22 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44124 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZFEQ1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xZ0lgldW9K+HusP3WYc2FescX85UDhq+qYIjPU2TTvnOxYP9kYh9D6kB7ofLBR4kAn
         eOTmvqbn2XLPG7/Cm1AVOBW1Jb6YzG0IrtnzmsZSeMAyQN/YKsY9+tko10qw9oe9fxTm
         rGdmyWt44YqK/1KXXCxD8I5i8Bb1z3JwLcFmk=
MIME-Version: 1.0
In-Reply-To: <20090604234911.GC5460@sortiz.org>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
	 <1244140576-18006-3-git-send-email-philipp.zabel@gmail.com>
	 <20090604234911.GC5460@sortiz.org>
Date: Fri, 5 Jun 2009 18:27:20 +0200
Message-ID: <74d0deb30906050927i428f732ehc76ac592c87d44b3@mail.gmail.com>
Subject: Re: [PATCH 2/7] MFD: ASIC3: add clock handling for MFD cells
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 1:49 AM, Samuel Ortiz<sameo@openedhand.com> wrote:
> Hi Philipp,
>
> On Thu, Jun 04, 2009 at 08:36:11PM +0200, Philipp Zabel wrote:
>> +
>> +struct asic3_clk {
>> +     int enabled;
> You probably want to use a kref here.
>
>> +static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
>> +{
>> +     unsigned long flags;
>> +     u32 cdex;
>> +
>> +     spin_lock_irqsave(&asic->lock, flags);
>> +     if (clk->enabled++ == 0) {
> using the kref API here would definitely be nicer.

While I agree that the kref API looks nice, I'm not convinced it is
intended to be used in this case. We are not counting references here.
There is no way to get the count back from the API, which we need to
decide whether or not to flip the CDEX bits. We could misuse the
release function pointer given to kref_put to turn off the clock, but
I'd prefer to leave it the way it is now.

regards
Philipp
