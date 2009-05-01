Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZEAJXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZEAJXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEAJXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:23:32 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:52355 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZEAJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:23:31 -0400
Message-ID: <49FABF8C.7000505@monstr.eu>
Date: Fri, 01 May 2009 11:23:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/27] add generic lib/checksum.c
References: <cover.1241105648.git.arnd@arndb.de> <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de> <20090501092027.GA29366@flint.arm.linux.org.uk>
In-Reply-To: <20090501092027.GA29366@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Tue, Mar 31, 2009 at 03:30:31PM +0200, Arnd Bergmann wrote:
>> +/*
>> + * copy from fs while checksumming, otherwise like csum_partial
>> + */
>> +__wsum
>> +csum_partial_copy_from_user(const void __user *src, void *dst, int len,
>> +						__wsum sum, int *csum_err)
>> +{
>> +	if (csum_err)
>> +		*csum_err = 0;
>> +	memcpy(dst, src, len);
> 
> Since when has 'memcpy' been valid from user addresses?
> 
yes, that's wrong

copy_from_user(dst, src, len);

should be there

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
