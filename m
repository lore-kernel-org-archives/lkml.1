Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbYAKVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbYAKVa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbYAKVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:30:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760222AbYAKVaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:30:12 -0500
Message-ID: <4787DFE2.2000504@redhat.com>
Date: Fri, 11 Jan 2008 16:30:10 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: LIBATA SCSI command validation changed in 2.6.24
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 607126c2a21cd6e9bb807fdd415c1a992f7b9009 changed command validation
to allow short commands in 16-byte CDBs, but it also made checking more
strict. Before the change, a 10-byte SG_IO command could have its length set
to 9 and still work. Now it fails. Not sure if this is a bug, but it has
caused at least one application to fail that used to work (qpxtool.)

[https://bugzilla.redhat.com/show_bug.cgi?id=428281]
