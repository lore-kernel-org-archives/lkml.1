Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZLIScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZLIScx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZLIScv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:32:51 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:46377 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZLIScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AmG8Oe0qODhV+UDEPvzbUTO1Aq+QgrLaUS93JKrq17iTEgYTvqUvXbWQqi3tbcFr3R
         +kOmhOiABajgu8xYRIhDlCgmRp1Ij2bjduCUSxRpnzrsCVirGYvz/rsf9lj+3+aQqzZy
         9Hc19OKuWAKcYsGbGPoLskZdoL6UBOEKPChxA=
MIME-Version: 1.0
In-Reply-To: <20091209085224.GB5129@elte.hu>
References: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
	 <4-1000-25639-1260344705-9533@rere.qmqm.pl>
	 <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>
	 <20091209085224.GB5129@elte.hu>
Date: Wed, 9 Dec 2009 10:32:57 -0800
Message-ID: <86802c440912091032q5fabe27ag9a699e484828a0e6@mail.gmail.com>
Subject: Re: [PATCH 3/7] mtrr: Remove use_intel()
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Micha? Miros?aw" <mirq-linux@rere.qmqm.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 12:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> can you check it with amd64 cpu?
>
> do you have a suspicion that it might be broken?

void __init mtrr_bp_init(void)
{
        u32 phys_addr;

        init_ifs();

        phys_addr = 32;

        if (cpu_has_mtrr) {
                mtrr_if = &generic_mtrr_ops;
                size_or_mask = 0xff000000;                      /* 36 bits */
                size_and_mask = 0x00f00000;
                phys_addr = 36;

and in generic_mtrr_ops
/*
 * Generic structure...
 */
struct mtrr_ops generic_mtrr_ops = {
        .use_intel_if           = 1,
        .set_all                = generic_set_all,

so all cpus that cpuid tell us that there is mtrr support, will all
have use_intel() == 1

YH
