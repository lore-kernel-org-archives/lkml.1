Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYK0M0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYK0M0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYK0M0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:26:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:57321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0M0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=hR1O5aqf0ERcTOThG9tDopBsAphaspjvGb2THx0pfJiK4vtecAhhioKh9STZVu8SNj
         jlsSy5MkofnnKjpIqGeaHrmMBLjzPsmb472Micor04x6f9MY/HfweQlz2ljO2o89EcMD
         JqUFYrmyiPmQHkdy3TbT1XNnTCqY+Vjl+IbO0=
Message-ID: <7c86c4470811270425i435a2adcq565d674070fd44db@mail.gmail.com>
Date: Thu, 27 Nov 2008 13:25:59 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org,
       sfr@canb.auug.org.au, "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20081126165948.GA15755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <20081126140027.GC6562@elte.hu> <20081126165948.GA15755@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Given that this thread discusses the syscall API, I would like to verify
something with you at this point.

The sys_pfm_create() syscall is used to create a perfmon session (context).
In the current patchset, where only counting is supported, the syscall is
defined as:

  int pfm_create(int flags, pfarg_sinfo_t *sif);

The plan is to extend this syscall, instead of adding a new syscall,
to add support
for sampling. The syscall would be used to select which sampling
buffer format and for passing
potential arguments to that format. The syscall would then look like:

 int pfm_create(int flags, pfarg_sinfo_t *sif, char *fmt_name, void
*fmt_arg, size_t arg_sz);

The kernel would look at the last 3 arguments ONLY if it saw the
PFM_FL_SMPL_FMT bit
 set in flags. We follow the model used by open(2).

I want to double-check that you are fine with this approach.
