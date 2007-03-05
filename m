Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbXCESG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbXCESG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXCESG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:06:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:19408 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbXCESG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eateZEXbYQQDb22duodJ/OWoIaCoN4Ruf8/SSCq9oMpQy4qgEiAsyXNsUaRlAjsuKvcsyHbz8+yHwQ6BYZ3zAlxRTYURdVZNpUovZPhM6+lftU8rF2shLIDppAbSlD8mTrpb/VxF9fKUANPu9V3dg6uF7sC60pz/x/yIXyDIv44=
Message-ID: <29495f1d0703051006k7b4c7ad1uaa7e85cbccb96f1b@mail.gmail.com>
Date: Mon, 5 Mar 2007 10:06:56 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: Mockern@yandex.ru
Subject: Re: timeout = 1 millisecond for wait_event_timeout
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45EC4C34.000001.31254@webmail11.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45EC4C34.000001.31254@webmail11.yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Mockern <Mockern@yandex.ru> wrote:
> Hi,
>
> I have a question. How can I make timeout = 1 millisecond for wait_event_timeout
> function?
>
> Something like (HZ/1000)*x?

You mean in a HZ-independent way?

Use msecs_to_jiffies().

Note, that if HZ==1000, you can do wait_event-( , ,0); and you will
get as close to 1 millisecond as possible (there are no guarantees for
schedule_timeout(), the underlying function to wait_event_timeout()).

Thanks,
Nish
