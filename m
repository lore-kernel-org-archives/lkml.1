Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZH0AHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZH0AHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 20:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZH0AHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 20:07:06 -0400
Received: from rtr.ca ([76.10.145.34]:53156 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZH0AHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 20:07:05 -0400
Message-ID: <4A95CE31.80404@rtr.ca>
Date: Wed, 26 Aug 2009 20:07:13 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrei Tanas <andrei@tanas.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: MD/RAID: what's wrong with sector 1953519935?
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost>
In-Reply-To: <1571f45804875514762f60c0097171e6@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrei Tanas wrote:
> On Wed, 26 Aug 2009 11:39:38 -0400, Ric Wheeler <rwheeler@redhat.com>
> wrote:
>> On 08/26/2009 10:46 AM, Andrei Tanas wrote:
>>> On Wed, 26 Aug 2009 06:34:14 -0400, Ric Wheeler<rwheeler@redhat.com>
>>> wrote:
>>>> On 08/25/2009 11:45 PM, Andrei Tanas wrote:
>>>>>>>> I would suggest that Andrei might try to write and clear the IO
>>>>>> error
>>>>>>>> at that
>>>>>>>> offset. You can use Mark Lord's hdparm to clear a specific sector
..
> [90318.370625] end_request: I/O error, dev sdb, sector 1953519935
..

I suggest you try this:

    hdparm --read-sector 1953519935 /dev/sdb

If that succeeds, then the sector is good at the drive.
But *If* it fails, then you could check the syslog to ensure
that it didn't fail for some weird reason, and then *fix* it:

    hdparm --write-sector 1953519935 /dev/sdb

This is very different from how 'dd' does writes.

Cheers
