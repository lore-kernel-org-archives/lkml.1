Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZBIV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZBIV1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZBIV1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:27:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:11346 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbZBIV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fLGEGCP8AhuKbil4GhM3f2C5lvA06h86GVQ3WfpC0NdYgeAPzHJYTEMw11nOtje6xP
         bL6DvomsNsUGUFZkSpa50B3dJrtcVkJbGK0bqjFzAueUBk6vt/Q4uTS2YZLrRRbYjKM4
         dvDiRWM6GW1gUZy6SUgQMjCEPWmGQmUix2DW4=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.1.10.0902100823170.1282@tundra.namei.org>
References: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>
	 <alpine.LRH.1.10.0902100823170.1282@tundra.namei.org>
Date: Mon, 9 Feb 2009 16:27:12 -0500
Message-ID: <8bd0f97a0902091327m3a71bf4ex46a391436481032d@mail.gmail.com>
Subject: Re: ima changes to shmem breaks !CONFIG_SHMEM
From: Mike Frysinger <vapier.adi@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 16:23, James Morris wrote:
> On Mon, 9 Feb 2009, Mike Frysinger wrote:
>> commit 1df9f0a73178718969ae47d813b8e7aab2cf073c broke default building
>> for Blackfin systems:
>>   CC      mm/shmem.o
>> mm/shmem.c: In function 'shmem_zero_setup':
>> mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
>> make[1]: *** [mm/shmem.o] Error 1
>>
>> that's because the ima.h include was added behind the CONFIG_SHMEM
>> markings rather than everywhere, just like the function is used.
>
> Does this seem like the correct fix?

it converts the build error to a build warning:
  CC      mm/shmem.o
In file included from mm/shmem.c:32:
include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
parameter list
include/linux/ima.h:25: warning: its scope is only this definition or
declaration, which is probably not what you want
-mike
