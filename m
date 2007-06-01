Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbXFACs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbXFACs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbXFACsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:48:50 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64476 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXFACst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:48:49 -0400
Date: Thu, 31 May 2007 20:48:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
In-reply-to: <fa.pq45zUHWQMSHoRGL/M4uTPfFWHg@ifi.uio.no>
To: Uncle George <netbeans@gatworks.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Message-id: <465F891B.1080103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.qaWJQn9l1jDV+N9wFv9WqATf44U@ifi.uio.no>
 <fa.pq45zUHWQMSHoRGL/M4uTPfFWHg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uncle George wrote:
> David Schwartz wrote:
> 
>> Nope. An errored connection is always ready for read/write -- there is
>> nothing to wait for as far as the kernel is concerned. Your code keeps
>> asking the kernel if something interesting has happened, the kernel keeps
>> telling it yes, and it refuses to do anything about it.
>>
> The select() returns because i pulled the USB cable from hub. Seems 
> reasonable.
> 
> The next select() found what? to be interesting in order to prematurely 
> terminate the select-wait? As far as I can tell, nothing interesting has 
> happened since the previous select(). In this case the select() is only 
> looking at read()'s.

It's because you haven't done anything to handle the error which is 
still persisting. Likely the only thing sane you can do in this case is 
close the fd and try to reopen it later.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

