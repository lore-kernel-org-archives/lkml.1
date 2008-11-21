Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYKUFnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYKUFnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 00:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYKUFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 00:43:00 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:27967 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKUFm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 00:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aruxl/hCv/KLWWyreoHiHCS0pWCETwV6H8AkY3/9eSTqjN20vogLpOSv32UImuRmsO
         ssTKRePEb0dcs3yuvB03OHalHZzEBzByoo8D0U5XrURUfLLDmXfpUZllX7cL4MWnoDIh
         atvG3RTEwGixDXA98dCICU6+1ZMrtz8P6Kl4w=
Message-ID: <804dabb00811202142y799fb70dxf89a1fc3514d78b1@mail.gmail.com>
Date: Fri, 21 Nov 2008 13:42:56 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: A question sort_main_extable()
Cc: "Sam Ravnborg" <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside start_kernel() there is a call to sort_main_extable().

void sort_extable(struct exception_table_entry *start,
                 struct exception_table_entry *finish)
{
       sort(start, finish - start, sizeof(struct exception_table_entry),
            cmp_ex, NULL);
}

With reference to
http://tuxology.net/2008/07/08/benchmarking-boot-latency-on-x86/, I
think it can help bootup latency (how much I got no number) if the
sorting is done post-compilation time, instead of dynamically
everytime the system bootup.  (perhaps at the stage of modposting,
when all the vmlinux, kernel modules objects have been generated, so
extracting out the exceptions strings is possible?)  Is this a
possible optimization?

Sam, can it be done?

Thanks.


-- 
Regards,
Peter Teoh
