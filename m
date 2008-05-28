Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYE1QM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYE1QM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYE1QMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:12:13 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:1855 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYE1QMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PbjEVyG7D+a7LSHjLOMjH6yNkHtBknu8H29aSMBVEF8Nl/L0DI5TH36NpE125p/7TAsj9FViiTsZ5j8ebGSx02tREdHv3KYYFh18GxGYV2Hzk1Q7N9GA38Vw4YQ0yGtGdZo9e5/sqWASwL0qewCpdwHznPp8w1Xd9voaS48sG0w=
Subject: Re: [RFC][Patch 2/5]integrity: TPM internel kernel interface
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528001739.54c630f9.akpm@linux-foundation.org>
References: <1211555021.16195.14.camel@new-host>
	 <20080528001739.54c630f9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 09:12:12 -0700
Message-Id: <1211991132.5964.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 00:17 -0700, Andrew Morton wrote:
> On Fri, 23 May 2008 11:03:41 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > +	index = cpu_to_be32(pcr_idx);
> > +	memcpy(data + 10, &index, 4);
> > +	rc = tpm_transmit(chip, data, sizeof(data));
> > +	if (rc > 0)
> > +		rc = be32_to_cpu(*((u32 *) (data + 6)));
> 
> An unaligned access.  What architectures is this hardware available on?
> 
> Harvey might be able to suggest a neater and better way of doing this?
> At least a get_unaligned(), I think?
> 

	rc = get_unaligned_be32((__be32 *)(data + 6));

If it was aligned:

	rc = be32_to_cpup((__be32 *)(data + 6));

Cheers,

Harvey



