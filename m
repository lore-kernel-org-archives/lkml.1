Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbXGIT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbXGIT6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXGIT6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:58:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:1661 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbXGIT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=L9UGqaZMHQ9VhbiOBd0DVHI4XdIhtjleG3nzhNiIGqdQKvhV2bRq5pNOzYR5US+vD0DqW0sWiLGtTtwDkzuW8C8VG2HtCq+4NV903eBELkiIxxQ9imLY+x/mCpSarY7MWW627GnUSE/9P6WAXJr0c8Odsjim7M9eUbDKrWZuQ7s=
Message-ID: <7f30c4c70707091258v12bed301ide0636950a01db86@mail.gmail.com>
Date: Mon, 9 Jul 2007 14:58:23 -0500
From: "hackmiester (Hunter Fuller)" <hackmiester@hackmiester.com>
To: linux-kernel@vger.kernel.org
Subject: PAM LDAP auth issue, but only on some apps...???
Cc: inaki@ploximeth.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 60f5e0bdab11d0d6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check this out.

[hack@asuka pam.d]$ sudo -u hfuller echo "testing"
Password:
testing

So I can run commands as an LDAP user hfuller, using sudo.

But!

[hack@asuka pam.d]$ su hfuller
Password:
[hack@asuka pam.d]$

If I try to su to the user, it doesn't work, and it doesn't even error out. And:

Jul  9 10:46:39 asuka su(pam_unix)[13051]: session opened for user
hfuller by (uid=0)
Jul  9 10:46:39 asuka su(pam_unix)[13051]: session closed for user hfuller

A session is opened for my user but then immediately closed. And this
is the error ssh throws:

Jul  9 11:59:18 asuka sshd2[13466]: Remote host disconnected:
Authentication method disabled. (user 'hfuller', client address '1
27.0.0.1:48784', requested service 'ssh-connection')
Jul  9 11:59:18 asuka sshd2[13466]: User authentication failed:
'Authentication method disabled. (user 'hfuller', client address
 '127.0.0.1:48784', requested service 'ssh-connection')'

If I try to ssh to localhost using the login hfuller.

If you know stuff about LDAP logins you might be thinking "His LDAP is
broken when using PAM but not NSS."

But here is this test program I was given, that uses PAM libraries...

[hack@asuka pam.d]$ ~hack/check_user
login: hfuller
Password:
PAM said: Success

What?!

Any ideas? This is one of the most confusing problems I've ever had.

-- 
-hackmiester
