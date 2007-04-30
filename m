Return-Path: <linux-kernel-owner+w=401wt.eu-S1946870AbXD3Wwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946870AbXD3Wwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946871AbXD3Wwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:52:45 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:7880 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946870AbXD3Wwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NaU5dYN9xSdEHR9dE11fqpVdtZwOuA4i/YRKzFUL0CYudegJezPs8yh85Ce5zLC92AYQo3+0v/4s8lsYRM1tUpp8GWudyxBqRjgGHi7EhfStMNcjfPoqA6fhIuzqt5IpcLm3XvTdAYkWvXqD5wRaMrGJvJ69DsllpyemeVKDOvM=
Message-ID: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
Date: Mon, 30 Apr 2007 17:52:43 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: SMB2 file system - should it be a distinct module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During SambaXP conference last week, one of the Samba 4 developers
talked about the work  doing a prototype server for SMB2 protocol
which got me thinking about the client side of this again.

As some background Windows Vista includes support for a new network
file system protocol, SMB2 (which is the default used on mount ie NET
USE or equivalent).  It is somewhat related to CIFS, although the
header format is bigger, better aligned and more of the operations are
handle based (rather than path based).  SMB2 is somewhat better than
CIFS in a few ways (although we would have to add Unix Extensions as
we have with CIFS to make it ideal for Linux).

Now that we (Samba team) understand enough about it to implement
prototypes (there is a prototype server in Samba 4, and a userspace
client library for testing), we need to decide whether the kernel
implementation of SMB2 client should be a distinct module or just part
of the cifs.ko module.

SMB2 (the protocol) is smaller than cifs, and obviously no backlevel
dialects to support (only slightly more than 12 different SMB2 network
commands would have to be used, although two have a couple of
different information levels each that the client would need to send).
 My guess is that less than 1/3 of the cifs module would overlap - but
that overlap is enough that it would be easier to do smb2 as part of
cifs (although it would make the cifs module somewhat larger).
During protocol negotiation (SMB Negotiate Protocol) SMB2 is listed as
a different dialect - if the server accepts SMB2 dialect then
subsequent commands begin with 0xFE instead of 0xFF and the header
fields are bigger and better aligned.

Any idea which would be preferred (smb2 support as part of cifs, or as
a distinct smb2.ko module)?

-- 
Thanks,

Steve
