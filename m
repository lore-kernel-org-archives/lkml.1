Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbXDCJSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbXDCJSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXDCJSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:18:15 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:43263 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964844AbXDCJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:18:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=aOOrKUihvkDDN5re0cGW6gHKsahjjASgSVycWSK060pFYjKbt7gsP3onvFpcR8e8bO9XCQOtBjiIv4Zw+6q/SZabmoZFpOpCzUsoaiwzEt5AgmY3nYYiNHwpE+6DnJkxOEQk2yGNwvm3H0p12m33aou4IxHGxownoR/rBE3SohU=  ;
X-YMail-OSG: FkXarZMVM1npAusbZB1RIVd6YX03YsGnFAhoSx7.0eRk3XGfel33ge_ZNDBLewnxNU87zGqYbA--
Message-ID: <46121BCF.50401@yahoo.com.au>
Date: Tue, 03 Apr 2007 19:18:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paa Paa <paapaa125@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl>
In-Reply-To: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa wrote:
> I'm using Linux 2.6.20.4. I noticed that I get lower SATA hard drive 
> throughput with 2.6.20.4 than with 2.6.19. The reason was that 2.6.20 
> enables NCQ by defauly (queue_depth = 31/32 instead of 0/32). Transfer 
> rate was measured using "hdparm -t":
> 
> With NCQ (queue_depth == 31): 50MB/s.
> Without NCQ (queue_depth == 0): 60MB/s.
> 
> 20% difference is quite a lot. This is with Intel ICH8R controller and 
> Western Digital WD1600YS hard disk in AHCI mode. I also used the next 
> command to cat-copy a biggish (540MB) file and time it:
> 
> rm temp && sync && time sh -c 'cat quite_big_file > temp && sync'
> 
> Here I noticed no differences at all with and without NCQ. The times 
> (real time) were basically the same in many successive runs. Around 19s.
> 
> Q: What conclusion can I make on "hdparm -t" results or can I make any 
> conclusions? Do I really have lower performance with NCQ or not? If I 
> do, is this because of my HD or because of kernel?

What IO scheduler are you using? If AS or CFQ, could you try with deadline?

-- 
SUSE Labs, Novell Inc.
