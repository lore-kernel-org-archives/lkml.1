Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYA3NoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYA3NoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYA3NoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:44:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:44787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYA3NoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RByNi1dxYONQTbtnkUX071/RdURXrKUxPVXB3sqRwOKsAjAAQFadElF3F76Htb0lEaUkVagt2FqBNpe8eP2A97R7e9WZUVpH27ryq0EhucXm79LDkne8F4zkv5xjSj93NoNUGwZA6LTjawRdXvcjNbP2LMgj+cOb/Fx6Y8nALJU=
Message-ID: <47A07F1D.9000208@gmail.com>
Date: Wed, 30 Jan 2008 14:43:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>	 <47A058B3.6000009@gmail.com>	 <200801300739.21344.rgetz@blackfin.uclinux.org> <386072610801300515j56d10f2ej55859500c91befbb@mail.gmail.com>
In-Reply-To: <386072610801300515j56d10f2ej55859500c91befbb@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2008 02:15 PM, Bryan Wu wrote:
> And one question for Jiri, what is the difference between misc char
> driver with other char drivers.

No difference in behaviour. Open function in misc replaces fops by your 
specified one (like a v4l or tty layer, or chrdev_open aswell, which will be 
called on each character device open).

> Because we got some other char drivers locally, maybe some day send them out.

Misc has one predefined major and is used for such uses, in which you need only 
one minor number. The point is not to block resting 254 minors of one major just 
for only one minor used.
