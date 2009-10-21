Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZJUN04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZJUN04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZJUN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:26:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55133 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZJUN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MuH8a6pveUU/7Eq7LMEXVFmgSDP7iYw10/BTaxtjP7r6jlamyI5J8L6EGmLZA3MZ7K
         h3JHexbcOrsNr0yHHWmAjDThBYyUTmc3PzVpgbDEbeMujQ9EKnBqiMYOwg522eVmAqWN
         /rgOIwMBwEO5xreZWYjZ8Vkoku3oeq7b8M/Gg=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 21 Oct 2009 15:26:50 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20091013044925.GA28181@us.ibm.com> <200910211037.38413.arnd@arndb.de> <20091021093338.GA11670@elf.ucw.cz>
In-Reply-To: <20091021093338.GA11670@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910211526.50584.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009, Pavel Machek wrote:
> > > Hmm, is there reason why pids are not at the end of struct
> > > clone_struct? Passing most parameters in special structure, then pids
> > > separately is strange...
> > 
> > I suggested doing that, it's a lot easier to handle fixed length data
> > structures than an array at the end.
> 
> You could still put the something * pids at the end of (fixed length)
> structure.
> 
> (Not that I agree with the argument, pid array is variable-length,
> anyway, and inlining it at the end of structure should not make code
> more complex).

Please read up on the v1 to v7 patches, we've been through all this
before. There are obviously a lot of ways to do it, many of which are
equally good. The important thing to note is that the user-visible
interface should *not* pass the structure into the library that provides
this function but build the structure itself, so it doesn't matter that
much.

If you put the array at the end of the data structure, the wrapper
will have to copy the array provided by the user to a temporary
buffer. Passing the array as a separate syscall argument avoids
this.

	Arnd <><
