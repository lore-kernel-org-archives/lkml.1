Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323Ab0AKBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0AKBjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219Ab0AKBjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:39:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35408 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AKBjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:39:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vQCLusi+RltaPiUu+yVlvw2UdCQtIHAYXQGLaxZPsjaaVW8MsoEDbr2VN1/wk8fpHo
         CKOmtEpCn+YiDRNOEZOPwmcE8Kf+OO8B6hUQjIwxA8mzFc/5Iy/9cQIN6OV18yeZwVXj
         uI87KjOETrWq85lEKhmZlLoIePw/2kzby5J+8=
Message-ID: <4B4A815A.60503@gmail.com>
Date: Sun, 10 Jan 2010 19:39:38 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>	 <4B484829.6060405@kernel.org> <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com> <4B4A7BC7.6060106@kernel.org>
In-Reply-To: <4B4A7BC7.6060106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2010 07:15 PM, Tejun Heo wrote:
> On 01/10/2010 01:33 PM, Torsten Kaiser wrote:
>> I did try the patch from Robert Hancock in
>> http://lkml.org/lkml/2010/1/6/417 ,but without success.
>>
>> if you need any more information, or have something for me to try,
>> please just ask. I did look at the code and the documentation about
>> enabling MSI, but did not see anything (obvious) wrong, so I don't
>> know what to try next.
>
> Can you please try the attached patch?
>
> Thanks.
>

It'd be interesting to see if it makes a difference, but I don't think 
the patch is quite right. According to the datasheet, doing the MSI ack 
while the interrupt source is still pending will cause a new MSI to be 
sent, so if you do it before handling the interrupt you'll generate a 
spurious interrupt after every real one.

Though, apparently my patch that did the MSI ack after the handling 
didn't help, so either that's wrong or the problem is unrelated. (I tend 
to suspect the latter, given that sata_nv is also failing in the same way.)
