Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0BSL5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:57:53 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:39136 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0BSL5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bi0ebMbP0Ka9Z4x7B/fblJPeRhYk+hDWAeb9oQftmHk2UiVs3pl3ShvO3+vf1bUqwj
         gpzllCx3g6a7UaH2KGvp9zIzEngdde/M6b/qI3rJxeROSPup4WL6vwz9nWdGHw3K9+vH
         af1IZNs4ySTgwUgyXl7npNklk6ovGc3SkxCmM=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <b6fcc0a1002190344s75ecfcf6y625591a0fa8e9869@mail.gmail.com>
Date: Fri, 19 Feb 2010 19:57:51 +0800
Message-ID: <628d1651002190357q1b17cf76o6585ce957d610ed8@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: wzt wzt <wzt.wzt@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe, but The attackers will use a complicated way to find the
security_ops address, it's a barrier to attackers. LSM is security
framework,  we don't want the attackers can easily to break it.  Just
like the sys_call_table variable in kernel 2.4.x(global and
writeable), evil drivers can extern the variable,  then replace the
Sys_X functions.

On Fri, Feb 19, 2010 at 7:44 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Sun, Feb 7, 2010 at 1:24 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
>> security_ops was declared as a global variable, so other drivers or
>> kernel code can easily change its value, like:
>
> With your patch they still can.
>
>> extern struct security_operations *security_ops;
>> security_ops = NULL;
>>
>> then insmod this driver immediately, it will get an oops.  Other evil
>> drivers can aslo fake this variable as extern.
>
