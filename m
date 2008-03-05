Return-Path: <linux-kernel-owner+w=401wt.eu-S1765294AbYCEKvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765294AbYCEKvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbYCEKvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:51:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61501 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761547AbYCEKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=q6kgz66loGdMxV0r1ogzCngZP8GLDgxuRoZDlZr+OskLcB2GXl8MoEvv8mUm6PYw/xaCa6cUTEx9i1sSuZflhspphcEMvehtefhwLmDk8SV3FBr5kV3GIdtvl4iUmxWjM0/GXFp5/93UGR4qY1bak0VXcNYgNUjE8V2iGCNDuVc=
Message-ID: <47CE7B1F.3000208@gmail.com>
Date: Wed, 05 Mar 2008 11:51:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Andrew G. Morgan" <morgan@kernel.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>
Subject: prctl(0x8) -> EINVAL [Was: 2.6.25-rc3-mm1]
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2008 10:19 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> +capabilities-implement-per-process-securebits.patch

This probably causes userspace damage:

dbus:
prctl(0x8, 0x1, 0, 0, 0)                = -1 EINVAL (Invalid argument)

named:
named: -u with Linux threads not supported: requires kernel support for 
prctl(PR_SET_KEEPCAPS)
prctl(0x8, 0x1, 0, 0, 0)          = -1 EINVAL (Invalid argument)

ntpd:
prctl(0x8, 0x1, 0xffffffffffffffa8, 0x1, 0) = -1 EINVAL (Invalid argument)
prctl(0x8, 0x1, 0, 0, 0)          = -1 EINVAL (Invalid argument)

$ grep CONFIG_SECURITY .config
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
