Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZK0XlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZK0XlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZK0XlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:41:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:47507 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZK0XlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:41:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=g6BOzy+VP9I//oqQoQbgYtTrXfBhh1pjcRb5MekrYt+H8pslT69p3V002DJFbazfJY
         jceilEArdvivOpgunxIuQz9eUitaPQN9xUvQTi1mYn3lmvGRZ1mKXMJMBpIabtIVj4zy
         rmEFZ8g3/kDDuapdPAwv1oToohP26xrvZcI64=
Message-ID: <4B1063A7.2030206@gmail.com>
Date: Sat, 28 Nov 2009 00:41:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH v3 00/27] writable limits
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I broke the threading to not mess up with the long thread.

In this version I got rid of the rlim access_only ugliness.

There are two things:
1)
<quote from=Ingo>
A prominent example would be the stack limit - we base address layout
decisions on it. Check arch/x86/mm/mmap.c. RLIM_INFINITY has a special
meaning plus we also set mmap_base() based on the rlim.
</quote>
Should there be some special handling of that? In standard setrlimit
there is none.

2)
<quote from=Oleg>
Hmm. you are right. Do you know why acct_file_reopen() does
	if (old_acct)
		do_acct_process();
???
</quote>
As I expressed myself before, I don't know why it is there (it doesn't
make sense to me either). But I took a look at when it was added. From
the very first merge of acct.c (2.1.68pre1) it was just in (name ==
NULL) path (turning acct off). Then in 2.1.126 it was switched to
account on every accounting file change.

I fear if we changed this, something would break.

thanks,
-- 
js
