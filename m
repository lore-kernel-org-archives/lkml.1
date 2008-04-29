Return-Path: <linux-kernel-owner+w=401wt.eu-S1764131AbYD2VAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764131AbYD2VAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbYD2U74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:59:56 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:17585 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022AbYD2U7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:59:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-kernel@vger.kernel.org
Subject: RFC: make MAINTAINERS email addresses easier to copy/paste
Date: Tue, 29 Apr 2008 14:59:56 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291459.56300.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like to use display names for email addresses, e.g.,
"Bjorn Helgaas <bjorn.helgaas@hp.com>" instead of just
"bjorn.helgaas@hp.com".

The current MAINTAINERS file format makes it a nuisance to
copy both the display name and the actual address.  So
I propose that we fold together the current "P:" and "M:"
lines using something similar to the filter below.

If we do this, we should fix a few inconsistencies in the
current file first so the script will work better.  I'll post
a patch to do that as a response to this message.

Bjorn


#!/usr/bin/perl

# Combine name and email address for easier copy and paste.
# For example, this:
#
#	P:	Bjorn Helgaas
#	M:	bjorn.helgaas@hp.com
#
# becomes this:
#
#	P:	Bjorn Helgaas <bjorn.helgaas@hp.com>

while (<>) {
    if (/^P:(\t|\s{2,})(\S.+)/) {
	if (defined($line)) {
	    print $line;
	    undef $line;
	}
	$name = $2;
	$line = $_;
    } elsif (/^M:(\t|\s{2,}).*?(\S+@\S+)/) {
	if (defined($line)) {
	    $mail = $2;
	    $mail =~ s/^<//;
	    $mail =~ s/>$//;
	    print "P:\t$name <$mail>\n";
	    undef $line;
	} else {
	    print;
	}
    } else {
	if (defined($line)) {
	    print $line;
	    undef $line;
	}
	print;
    }
}
