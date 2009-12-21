Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZLUH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZLUH5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZLUH5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:57:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43314 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZLUH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JOcggOmMxRt9MDyeimUren0ftWRJ/b+BxLlJPEHRfo9RgYbCY5F/y5nTJz51iFAa1a
         BLN9gKf+LRq28rvuj3cu7wIC0xWg6Mkr7ixPCzYxiuD06TFYcwxQRqOmpKvMVy7V47VY
         AV2oMYH22nrZNe8H2pwHOfyzCWGnmzRKTYUPk=
MIME-Version: 1.0
Date: Mon, 21 Dec 2009 09:57:32 +0200
Message-ID: <b6fcc0a0912202357g269722f2ra2cb136396e8186e@mail.gmail.com>
Subject: Re: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string sysctls
From: Alexey Dobriyan <adobriyan@gmail.com>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> new = alloc_rcu_string(MAX_GLOBAL_SIZE, GFP_KERNEL);

I think adding failure mode is not right.
We can get away with per-sysctl-string spinlock and not introduce yet
another API.
