Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYFCO34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYFCO34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYFCO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:29:49 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33012 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYFCO3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:29:48 -0400
Message-ID: <484554EE.6020007@s5r6.in-berlin.de>
Date: Tue, 03 Jun 2008 16:27:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Rick van Rein <rick@groengemak.nl>, daniel.blueman@gmail.com,
       david@lang.hm, linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
References: <20080602125904.GA15129@phantom.vanrein.org> <87prqzvc17.fsf@basil.nowhere.org> <20080602211027.GB18415@phantom.vanrein.org> <484495A7.6010006@firstfloor.org>
In-Reply-To: <484495A7.6010006@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Rick van Rein wrote:
>>> Rick van Rein <rick@groengemak.nl> writes:
>>>> Regarding I/O init: Current Linux boots while initiating one device at a
>>>> time.  Some degree of serialism must exist, but after scanning a bus would
>>>> it not be possible to fork threads to initiate each of the devices found
>>>> on it?
>>> 
>>> Multithreaded driver initialization has been tried, but reverted
>>> because it triggered too many driver bugs.
>>> 
>> Thanks for your responses.  You convinced me I/O initiatilisation cannot
>> be improved upon.
> 
> I'm sure it can. It's just significant work to do it and would need
> to be done step by step. It's a bit like the "remove BKL everywhere"
> project.

Several bus subsystems actually probe asynchronously (i.e. in parallel
to other bus subsystems) or even with some degree of internal parallelism.

Of course there are notable benefits in this only if the devices are
very slow to start up --- e.g. because they contain moving parts (this
kind of devices is not present in Rick's setup) or because they are
connected via high latency interconnects --- or if there is a massive
number of devices.
-- 
Stefan Richter
-=====-==--- -==- ---==
http://arcgraph.de/sr/
