Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZIHST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZIHST3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZIHST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:19:28 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:39010 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZIHST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=cPZQUqzWj++IrwidX9dSExvrgXygq0kw
	k7yR0kxdckWbM2rURg3Zk1biMhBDHpZ+8GKrb0RFhlm1GEworR0DLpQwp++JS9HW
	Hur1y1Ggub0VEy9OT5XbRTLMuMTkRnpPVoENvxmhlrcQBFUyo5nKS+mT+ahHKahl
	2AKsyee0Exc=
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
References: <20090907211302.GA5892@us.ibm.com>
 <20090907211700.GH6685@us.ibm.com>
From: Nathan Lynch <ntl@pobox.com>
Date: Tue, 08 Sep 2009 13:19:08 -0500
In-Reply-To: <20090907211700.GH6685@us.ibm.com> (Sukadev Bhattiprolu's
 message of "Mon\, 7 Sep 2009 14\:17\:00 -0700")
Message-ID: <m3zl95l2oz.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 210627D6-9CA4-11DE-B505-A13518FFA523-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suka,

I ran across an issue with this on ppc64.

> +static pid_t *copy_target_pids(void __user *upid_setp)
> +{
> +	int j;
> +	int rc;
> +	int size;
> +	int unum_pids;		/* # of pids specified by user */
> +	int knum_pids;		/* # of pids needed in kernel */
> +	pid_t *target_pids;
> +	struct pid_set pid_set;
> +
> +	if (!upid_setp)
> +		return NULL;
> +
> +	rc = copy_from_user(&pid_set, upid_setp, sizeof(pid_set));

This doesn't work on a 64-bit kernel when the process is 32-bit and uses
the definition of struct pid_set provided in types.h:

+struct pid_set {
+	int num_pids;
+	pid_t *pids;
+};

Shouldn't the pids field be u64 or some other type of fixed size?
