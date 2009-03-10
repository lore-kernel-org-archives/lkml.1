Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZCJXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZCJXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCJXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:37:21 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:65226 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZCJXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=HSLO4UrXu5j1wIbOBFMBYkbFBf6Ui0R68IxBFsdBgw7ghgdRmQShPBXyH+SUHmxC5w
         GtKoKGrZbf39Axdp5v2txwDTgBsfVtmGHE19zXdkkg56+WTGDvmyPGNPcDqNulLNexxA
         gzvT9SG116V5/16tBmZ5iVzmcw+/GJDNwoioQ=
Message-ID: <49B6F9A9.1030803@gmail.com>
Date: Tue, 10 Mar 2009 17:37:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Altobelli, David" <david.altobelli@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tweak spin logic for hpilo
References: <20090309225651.GA13702@ldl.fc.hp.com> <20090309160437.b71041d5.akpm@linux-foundation.org> <92D64232F2316045B18937D5C9996B1522834ABED6@GVW1144EXB.americas.hpqcorp.net>
In-Reply-To: <92D64232F2316045B18937D5C9996B1522834ABED6@GVW1144EXB.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Altobelli, David wrote:
>> From: Andrew Morton
>> David Altobelli wrote:
>>> Change hpilo open and close logic to spin for 10usec between checking
>>> device, rather than every usec.
>> err.. Why?
> 
> Because the loop is coded to take up to 10ms, it seemed prudent to increase
> the interval between polling the device, to reduce the load on the system and
> allow more other work to happen.

You're using udelay, which is a spin loop. Nothing else can happen on 
that CPU while it's delaying anyway.
