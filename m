Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYBHUrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYBHUrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYBHUqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:46:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43793 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYBHUqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:46:17 -0500
Date: Fri, 8 Feb 2008 21:46:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h IBS support for oProfile driver
Message-ID: <20080208204623.GG31984@uranus.ravnborg.org>
References: <47ACB571.8070507@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACB571.8070507@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitpicks only - and as I am not familiar
with this codebase I could not provide
proper code review.

	Sam

> +
> +	/*setup AMD Family10h IBS irq if needed */

Please add a space after '/*'
Several places.

>  static int nmi_create_files(struct super_block *sb, struct dentry *root)
>  {
>  	unsigned int i;
> +	struct dentry *dir;
> 
>  	for (i = 0; i < model->num_counters; ++i) {
> -		struct dentry *dir;
> +
>  		char buf[4];
Please drop this empty line

> @@ -391,6 +428,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  	__u8 vendor = boot_cpu_data.x86_vendor;
>  	__u8 family = boot_cpu_data.x86;
>  	char *cpu_type;
> +	uint32_t eax, ebx, ecx, edx;

We do not recommned use of uint32_t in the kernel. Use plain u32.
uint32_t belongs to a namespace outside the kernel.
(googling will find lots of discussion on the topic but I see code
just above using u8 so at least be consistent and use u32)

> +		/* see if IBS is available */
> +		if (family >= 0x10) {
> +			cpuid(0x80000001, &eax, &ebx, &ecx, &edx);

Two hardcoded numbers on two lines??

> +			if (ecx & 0x40)
And one more..

