Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZLHS4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZLHS4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZLHS4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:56:03 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44428 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbZLHS4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CKWWoMsowQyAzueQibwiop7bsTdLgWSK/4jwieFCt3rfBzmZEnNH2TP8KMmE17o0R6
         rA4l3TYyNURU2nsb6/nCBvPZvI4QuWCNfnISzsBGOoRyXjputKuyA1kIccASz/USmmdv
         RgPyVW1GpFxB7CsUMvKML5yN/5aL0gIen7qrA=
Message-ID: <4B1EA146.6040504@lwfinger.net>
Date: Tue, 08 Dec 2009 12:56:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Build failure with 2.6.32-3931-g6035ccd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building v2.6.32-3931-g6035ccd results in the following error:

net/sctp/sysctl.c:251: error: unknown field ‘strategy’ specified in
initializer
net/sctp/sysctl.c:251: error: ‘sysctl_intvec’ undeclared here (not in
a function)

The faulty commit is:

===============================
commit d7fc02c7bae7b1cf69269992cf880a43a350cdaa
Merge: ee1262d 28b4d5c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Dec 8 07:55:01 2009 -0800

-- snip --
      ...

    Fix up conflicts due to sysctl cleanups (dead sysctl_check code and
    CTL_UNNUMBERED removed) in
        kernel/sysctl_check.c
        net/ipv4/sysctl_net_ipv4.c
        net/ipv6/addrconf.c
        net/sctp/sysctl.c
===========================

The error comes from the "Fix up conflicts due to sysctl cleanups".

If you need my .config, I will be happy to post it.

Larry

