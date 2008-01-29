Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYA2WNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYA2WNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYA2WNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:13:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYA2WNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:13:12 -0500
Message-ID: <479FA428.3040806@zytor.com>
Date: Tue, 29 Jan 2008 14:09:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>	 <479E5D22.1070109@goop.org>	 <1201599251.5301.26.camel@localhost.localdomain>	 <479F6845.1070902@goop.org> <479F6AD2.8050908@zytor.com>	 <479F70E9.40905@goop.org>  <479F71B6.2010305@zytor.com>	 <1201639112.9516.23.camel@cthulhu.hellion.org.uk>	 <479F9FA4.8020504@zytor.com> <1201643758.9516.25.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201643758.9516.25.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Tue, 2008-01-29 at 13:50 -0800, H. Peter Anvin wrote:
>> Ian Campbell wrote:
>>> I finessed the length issue slightly since it happens that the word
>>> before the payload is the payload's length. I'm mulling a variety of
>>> options:
>>>       * declare it compression scheme dependant. At least for gzip
>> it
>>>         knows when it has reached the end.
>>>       * codify the length followed by data thing we happen to have
>> now
>>>       * add a length field to the header, using another 4 bytes (is
>>>         there any pressure on the size of the header?).
>>>
>>> I'd probably go with the later unless we are pressed for space in
>> the
>>> header.
>> I would agree with that.  In fact, while we're adding fields to the 
>> header, I would like to add a field that would be the CRC32 (or other 
>> simple integrity check) over the whole image.
> 
> As in over the whole compressed payload part? I'll add that while I'm
> there.
> 

I was actually thinking about the whole bzImage.

Obviously, it can't cover itself (unless it's something like a plain 
checksum) so presumably it would compute it with its own field set to zero.

	-hpa
