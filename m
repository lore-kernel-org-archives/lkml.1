Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbZDBUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbZDBUIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZDBUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:08:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:56855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbZDBUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
References: <200903311452.05210.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> 
	<20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> 
	<20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> 
	<20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> 
	<20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
Date: Thu, 2 Apr 2009 13:07:46 -0700
Message-ID: <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com>
Subject: Re: Ext4 and the "30 second window of death"
From: Ray Lee <ray-lk@madrabbit.org>
To: david@lang.hm
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 11:44 AM,  <david@lang.hm> wrote:
> let's not talk a database here, let's talk something simpler, like a POP3
> mail client (even though I strongly favor IMAP ;-)
>
> it wants to have the message saved before it deletes it from the server.
>
> how should it try to do this?
>
> the only portable method is to fsync the file after it's written and before
> sending the delete to the server.
>
> so your mail client _should_ issue fsync calls.

That's just not the case. Every POP fetcher I've seen offers an option
to leave seen messages on the server for some period measured in days.
Setting it to one day means that the data will eventually get flushed
by the time the message is deleted.

So, no, the mail client does not have to issue fsync()s at all. (If
dirty data can hang around unwritten for 24 hours, I'd argue that's a
misfeature of the filesystem or kernel.)

Alternately, a client could fetch once every half hour at which point
the cost of an fsync is amortized over all the fetched messages.
