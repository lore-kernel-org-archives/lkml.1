Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZG1LPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZG1LPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZG1LPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:15:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59556 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZG1LPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:15:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=b66jlPgXKoLn/MjXPH4Y5kpnbsRdIoxaXkaMcEdyxKfyP40VJxspmClht9T8kAchb
	EekoXc7It2dYrvApWP8yQ==
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0907272013070.20984@fbirervta.pbzchgretzou.qr>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
	 <20090727134616.12897.7639.stgit@jazzy.zrh.corp.google.com>
	 <alpine.LSU.2.00.0907272013070.20984@fbirervta.pbzchgretzou.qr>
Date: Tue, 28 Jul 2009 13:15:04 +0200
Message-ID: <b5ddba180907280415y4a9ef71i5cd90ca409b52965@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/5] IPVS: prefix EnterFunction and LeaveFunction msg 
	with "IPVS:"
From: Hannes Eder <heder@google.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 20:14, Jan Engelhardt<jengelh@medozas.de> wrote:
>
> On Monday 2009-07-27 15:46, Hannes Eder wrote:
>>
>>Now all printk messages from IPVS are prefixed with "IPVS:".
>>
>>+#define EnterFunction(level)                                                 \
>>+      do {                                                                   \
>>+              if (level <= ip_vs_get_debug_level())                          \
>>+                      printk(KERN_DEBUG "IPVS: Enter: %s, %s line %i\n",     \
>>+                              __func__, __FILE__, __LINE__);                 \
>>+      } while (0)
>>+#define LeaveFunction(level)                                                 \
>>+      do {                                                                   \
>>+              if (level <= ip_vs_get_debug_level())                          \
>>+                      printk(KERN_DEBUG "IPVS: Leave: %s, %s line %i\n",     \
>>+                              __func__, __FILE__, __LINE__);                 \
>>+      } while (0)
>
> I think you should rather make use of pr_fmt:
>
> <before any #includes>
> #define pr_fmt(x) "IPVS: " x
>
> And then use pr_<level>("Elvis has left the building") in code. This
> will add IPVS: automatically to all pr_* calls, alleviating the need
> to manually type it into all printks.

I like this idea.  I'll come up with an extra patch, it does not fit
into this series anyway.

> Of course, if you only want it for the two defines here, scrap
> my idea :)
>

Cheers,
-Hannes
