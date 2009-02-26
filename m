Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZBZHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZBZHCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZBZHCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:02:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:60289 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZBZHB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:01:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GIFnlblPhaSGr/Gc4g2PHg+VSrY9g2dtSlU/re6F9Uu1ap2AzIR1N8udZ6euCCV/DR
         QaCB0m4pKIIZilgGJtgE1ke8LFCpDhcrrgrDqSXo8J4n62cDdkGsImiVp+bsUPrkadyE
         i25f1904CxxPCdmpbViXxScUrIAxXjBY+NMgI=
MIME-Version: 1.0
In-Reply-To: <20090225044730.GA9106@july>
References: <20090225044730.GA9106@july>
Date: Thu, 26 Feb 2009 12:31:57 +0530
Message-ID: <5d5443650902252301l19d08e67t54c1cea004442be2@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 1730d73..7e96635 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -274,6 +274,8 @@ void input_event(struct input_dev *dev,
>                add_input_randomness(type, code, value);
>                input_handle_event(dev, type, code, value);
>                spin_unlock_irqrestore(&dev->event_lock, flags);
> +               if (type == EV_KEY)
> +                       input_notifier_call_chain(value, &code);

This check will be done for every input_report_xxx calls, even for
touchscreen events (in which case of course it will fail), and I don't
think this is optimal solution. Users should be given an option to
disable this if they don't need this notification mechanism.

How about moving this to input_report_key?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
