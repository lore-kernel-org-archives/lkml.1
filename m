Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbZDBU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbZDBU77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZDBU7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:59:51 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:16605 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbZDBU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:59:50 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbdalLaF0lu
X-RZG-CLASS-ID: mo05
Message-ID: <49D5273B.60806@ursus.ath.cx>
Date: Thu, 02 Apr 2009 22:59:39 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: david@lang.hm, Matthew Garrett <mjg59@srcf.ucam.org>,
       Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
References: <200903311452.05210.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> 	<20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> 	<20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> 	<20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> 	<20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com>
In-Reply-To: <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.04.2009 22:07 Ray Lee wrote:
> On Thu, Apr 2, 2009 at 11:44 AM,  <david@lang.hm> wrote:
>> let's not talk a database here, let's talk something simpler, like a POP3
>> mail client (even though I strongly favor IMAP ;-)
>>
>> it wants to have the message saved before it deletes it from the server.
>>
>> how should it try to do this?
>>
>> the only portable method is to fsync the file after it's written and before
>> sending the delete to the server.
>>
>> so your mail client _should_ issue fsync calls.
> 
> That's just not the case. Every POP fetcher I've seen offers an option
> to leave seen messages on the server for some period measured in days.
> Setting it to one day means that the data will eventually get flushed
> by the time the message is deleted.

Yes, but a lot of users (and I assume >90% of POP3 users) don't use this
option.

> So, no, the mail client does not have to issue fsync()s at all.

Except when operating in immediate-delete mode.

> Alternately, a client could fetch once every half hour at which point
> the cost of an fsync is amortized over all the fetched messages.

Again this is forcing a policy on how users should configure their clients.

And don't forget: POP3 was just an example. There can be a lot of other
applications as well. E.g. what about an application for the reception
of SMS or other mobile text messages? This is pushed to the client, not
polled as with POP3 AFAIK.

Andreas
