Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbXK2PNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbXK2PNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXK2PNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:13:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:36404 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK2PNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=v0C+VMIX3JMq+jbzSDPhP5qtAUOJ4hHplP7P6L1eiCl7LiwCJc6otR2thczcTk+tCNxrC4NgrU3m5gEush936YHBcmZ7ULRqWCL/88tD6O8nHlabekctNVNoq2OXu3AgpfePA6uLPs8zDMKCYq0LVlNmAJqOgaDcpd24zDpbDr4=
Message-ID: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com>
Date: Thu, 29 Nov 2007 07:13:41 -0800
From: "Dan Kegel" <dank@kegel.com>
To: linux-kernel@vger.kernel.org
Subject: Relax permissions for reading hard drive serial number?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 5798c39bfc2dbd49
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2000-09-07, in
http://marc.info/?l=linux-kernel&m=96836765403118&w=2, Linus wrote:
> Hmm.. I have this feeling that it would be much nicer to
> just implement the NT system calls directly.
> ...
> I wouldn't be adverse to supporting Wine better...

A few years on, Wine has matured to the point where it's
ready to run quite a few apps, even some protected by Safedisc.
One sticking point is that apps like Photoshop and probably
Punkbuster want to retrieve the hard drive's serial number,
but Linux restricts access to that info:
$ ls -l /proc/ide/hda/identify
-r-------- 1 root root 0 2007-11-29 07:05 /proc/ide/hda/identify
(And even if /proc/ide goes away, the other ways of retrieving
this info are similarly restricted to root.)

Any reason the access control on this info shouldn't be eased a bit,
e.g. make /proc/ide/*/identify be mode 444?

An alternative might be for Wine to simply fake the serial number,
but I would like to avoid that if possible.

See also http://bugs.winehq.org/show_bug.cgi?id=10018
- Dan
