Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYHFLLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYHFLLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYHFLLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:11:09 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:21712 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757167AbYHFLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:11:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=bBn9mewqQ5wE5MiEmF9JZP4JPyA9U9WATHuBy31IU9Pl0aZ3PB5jha8lwy30O/DPTqRY4yBcD1v9CaNKW35ufNYwAVYQojyzPlEJu7OqYsDasbhEtg/SPLkFpF/nJjrsx84QsBu6nsGtymhD+IR5S6GwNbwhvqQzO7jSbfdLo+4=  ;
X-YMail-OSG: rHD5KaAVM1my12dpBQsdQLJd.Fksi4eQxsPZXauqNXbEKfKDH90TIKUAZSq5zD6JSGqBApCGoqDPvgHAe0ueF2KWYBzrTJmWbot4IO5faUT3fXPKk_w8RLpgn0JZvJ83KhI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: tvrtko.ursulin@sophos.com
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface =?iso-8859-1?q?for=09on_access?= scanning
Date: Wed, 6 Aug 2008 21:10:58 +1000
User-Agent: KMail/1.9.5
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
References: <20080806094515.A6524316920@pmx1.sophos.com>
In-Reply-To: <20080806094515.A6524316920@pmx1.sophos.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808062110.58764.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 19:44, tvrtko.ursulin@sophos.com wrote:
> Nick Piggin wrote on 05/08/2008 19:08:05:
> > On Tuesday 05 August 2008 07:00, Eric Paris wrote:
> > > 5. Define which filesystems are cacheable and which are not
> >
> > This is practically impossible to do completely without rewriting a lot
> > of code (which will never be accepted). I don't see why it is needed
>
> though
>
> > as the filesystem cache is supposed to be kept coherent with disk.
>
> Problem is with network filesystems. So could it be a flag somewhere per
> filesystem which would say something like "this filesystem guarantees
> content of a file cannot change without get_write_access or
> file_update_time being called locally"? That doesn't sound like a lot of
> code so what am I missing?

Maybe... but that's not the same as what requirement 5 calls for.

But depending on exactly what semantics you really call for, it can get
tricky to account for all of pagecache. Writes can happen through page
tables or get_user_pages. True that a process has to at some point have
write permission to the file, but the cache itself could be modified
even after the file is closed and all mmaps disappear.
