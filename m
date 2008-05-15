Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYEOHor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYEOHor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYEOHoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:44:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:39060 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYEOHoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ql/ZuG/CxU9HGDfd1i6u5eJSbczYYgFAwIjpBj2jZiudbLCVemrJgOs3ycQGa8nDErBu4WPW4T+flons8uSTFFDJXxfH2D3M/S3cNWLmCe3DHfX2Hbw/o+HeYINmajZf1lnoNyURjr9Gbk6V5xxOHOw42sAhKIvExRysu/C78I0=
Message-ID: <38b2ab8a0805150044q3f336d64v20dd5ac78a2c1af2@mail.gmail.com>
Date: Thu, 15 May 2008 09:44:37 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: How to avoid data copies in a driver ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080514200250.GB7579@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
	 <20080514200250.GB7579@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:02 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Wed, May 14, 2008 at 09:54:03PM +0200, Francis Moreau wrote:
>> Hello,
>>
>> I'd like to optimize my driver, which receives data through a fifo and gives
>> them to a user space application. In turns this application moves this data
>> into a file.
>>
>> To avoid several useless copies, I'd like the application to pass to the driver
>> a  file descriptor (?) to  the driver and then the driver can directly move the
>> received data to that file.
>>
>> Could anybody give me some example of such scheme ?
>
> If the application memory mapped the file, would it be able to simply
> pass a pointer to that mapped file as part of the call to the driver and
> the driver would place the data directly at the requested location which
> would then be directly to the file?
>

So I would need to map this pointer into the kernel space, then fill it, take
care of cache coherency, unmap the kernel pointer.

Do you have any example of that in the kernel tree ?

BTW, data are received in interrupt context. Is it safe to put them in mapped
memory  (can I have page fault ?) in this context ?

Thanks
-- 
Francis
