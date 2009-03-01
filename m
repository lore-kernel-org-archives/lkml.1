Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbZCATvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbZCATvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 14:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZCATvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 14:51:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:42258 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZCATva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 14:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=RQUmfw2lQf2pKSp8rAUqL70GuMnMDoKY73e46/HCqLQ6OqkOhil1FblxojoJ4M2P9N
         YmpVhcpqW4/fMtC6eMlvRFPs+NiPEcWo4WrbWJCpSKjET17lT0TBnYaya6Tnaf2wraAK
         PwOS1lGsKb3G1521DCPDjcvRsLZgdaEZ5UMqA=
Message-ID: <49AAE73D.1010707@gmail.com>
Date: Sun, 01 Mar 2009 13:51:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Daniel Mack <daniel@caiaq.de>
CC: Pavel Machek <pavel@suse.cz>,
       =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
References: <20090301132953.GF20813@buzzloop.caiaq.de>
In-Reply-To: <20090301132953.GF20813@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> Hi Pavel, Eric,
> 
> are there any plans to free the lis3 driver from its ACPI dependency?
> In fact, this device is I2C/SPI connected which the ACPI layer seems to
> hide from the driver, but to use it on embedded devices, the bus drivers
> must be used directly and the dependeny seems entirely unnecessary
> anyway.

If ACPI AML code attempts to access the device (which it obviously does, 
  since we're presumably using the same code to access it), then we 
cannot be accessing it directly at the same time, otherwise the two will 
stomp on each other.

> 
> Also I got the feeling that using a globally exported 'adev' symbol all
> over the different layers is not the best practice - I suspect all the
> occasions could be solved with private pointers and/or container_of().
> Isn't there any cleanup pending?
> 
> Thanks and best regards,
> Daniel
> 

