Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZEMK5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZEMK5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZEMK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:57:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:26012 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZEMK52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JMNoGuYezovUXliAmnld4Ap7xscD/YyOOKT9Q1nECmDXk1h0/QzFJNeYV7+YmVBEnr
         jOgyUuq8RJE65R9qy2T5P4fSMBxRi2cYNrC5XIzvK+wZgAyrAe2j9P7S9S2Zj3pmam6X
         8nIRNdlA/47oHAHtghclJXi5CxSciroYktwTA=
MIME-Version: 1.0
In-Reply-To: <1242119872.16400.113.camel@demuxf9c>
References: <1242119872.16400.113.camel@demuxf9c>
Date: Wed, 13 May 2009 18:57:28 +0800
X-Google-Sender-Auth: 0fc930bc29b935a4
Message-ID: <2a27d3730905130357re0adf41l19f5603a70dac57b@mail.gmail.com>
Subject: Re: RapidIO - general questions
From: Li Yang <leoli@freescale.com>
To: Jan Neskudla <jan.neskudla.ext@nsn.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ed LKML

On Tue, May 12, 2009 at 5:17 PM, Jan Neskudla <jan.neskudla.ext@nsn.com> wrote:
> Hallo
>
> we'd likes to use a RapidIO as a general communication bus on our new
> product, and so I have some questions about general design of Linux RIO
> subsystem. I did not find any better mailing list for RapidIO
> discussion.
>
> [1] - we'd like to implement following features
>    * Hot-plug (hot-insert/hot-remove) of devices
>    * Error handling (port-write packets - configuration, handling of
> them)
>    * Static ID configuration based on port numbers
>    * Aux driver - basic driver, for sending messages over different
> mboxes, handling ranges of doorbells
>
>    Is it here anyone who is working on any improvement, or anyone who
> knows the development plans for RapidIO subsystem?
>

AFAIK, there is no one currently working on these features for Linux.
It will be good if you can add these useful features.

> [2] - I have a following problem with a current implementation of
> loading drivers. The driver probe-function call is based on comparison
> of VendorID (VID) and DeviceID (DID) only. Thus if I have 3 devices with
> same DID and VID connected to the same network (bus), the driver is
> loaded 3times, instead only once for the actual device Master port.

This should be the correct way as you actually have 3 instances of the device.

>
> Rionet driver solved this by enabling to call initialization function
> just once, and it expect that this is the Master port.

Rionet is kind of special.  It's not working like a simple device
driver, but more like a customized protocol stack to support multiple
ethernet over rio links.

>
> Is it this correct behavior  ? It looks to me that RapidIO is handled
> like a local bus (like PCI)

This is correct behavior.  All of them are using Linux device/driver
infrastructure, but rionet is a special device.

- Leo
