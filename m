Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZJTV6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZJTV6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZJTV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:58:14 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:32775 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZJTV6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:58:13 -0400
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 14:58:17 -0700
Message-ID: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
Subject: libaio asynchronous syscall io_getevents blocks on error
From: Zubin Dittia <zubin@tintri.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing a program that uses the kernel's io_submit/io_getevents
system calls.  What I would like to be able to do is submit N
operations for i/o on different files, and then call io_getevents with
min_nr = nr = N and a timeout of NULL, so that I can block until all N
operations have completed.  This works great, except when one of the
operations has an error (eg., if one of the descriptors is invalid).
In this case, the call to io_getevents appears to block indefinitely.
Shouldn't an error on one of the submitted operations count as a
completion event for that operation, so I can check the error code
when the call returns?  Any help would be appreciated.
Thanks in advance,
-Zubin
