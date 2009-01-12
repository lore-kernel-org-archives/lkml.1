Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZALTJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZALTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZALTJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:09:33 -0500
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41560 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbZALTJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c5OfGcr/D8FRu0lxX4FbeW/Uee4qms4VDdeZ7g9z/8h4soqrR4vyJ1abIB52iqG/W2
         Tp2B4B3A3BXhm1ZPCTanfBqswq07HrnhMj762vtnAz0/FNUtMJUbFwQECHNbKELjCFhm
         q3kwbTlpPqv++U7jPW4ZQOuHPHJzjz+0aQqRg=
Message-ID: <3e8340490901121109w2569a820g2e979367fcca886b@mail.gmail.com>
Date: Mon, 12 Jan 2009 14:09:26 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: RFC: Network privilege separation.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Michael Stone" <michael@laptop.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <12821.1231785850@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231307334-9542-1-git-send-email-michael@laptop.org>
	 <87mye2yg8a.fsf@basil.nowhere.org>
	 <20090108023111.GJ3164@didacte.laptop.org>
	 <20090108104305.7b271053@lxorguk.ukuu.org.uk>
	 <12821.1231785850@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 1:44 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 08 Jan 2009 10:43:05 GMT, Alan Cox said:
>
>> If you have the same uid then you can just use ptrace to drive another
>> task with that uid to do the creations for you. Chances are you can also
>> attack shared executable files (eg that uids .bashrc)
>>
>> That to me says controlling network access is only useful as part of a
>> more fine grained and general purpose interface. We already have that
>> interface in the form of things like SELinux. We already have systems
>> actively using it to control stuff like which ports are accessed by some
>> services.
>
> Yes, the network access part *is* something that should be part of a more
> general interface.  Having said that, we currently are lacking a way for a
> *general user* program to say "I'm all set up, and would like to disavow any
> other further resource access (except maybe r/o access as "other" to file
> systems)".
>
> It's pretty easy for stuff running as root to play setuid()/capability() games
> to throw away access rights.  It's damned hard for mortal users to do it.

Would this be something covered by namespaces? Eg, once you're done
with setup, clone into a new network and UID namespace. Now you have
no network interfaces, so you shouldn't be able to make any new
connections, and you won't be able to access any files except those
with 'other' access rights, right?
