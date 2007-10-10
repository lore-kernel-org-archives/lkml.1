Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbXJJTtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbXJJTtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXJJTs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:48:57 -0400
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:22669 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755482AbXJJTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:48:56 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 15:48:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=cRtDbMlYN9P3auHs+BpGZAa7ZR0uvN0pjedwx4axUZRguB4r35YapDIpKw/GsH+4jaY35bepXjFSYT5Xib12FVOYAg4vLfza2CJL7lX96HTX3dHGtH3+v3L2xhY/yHJEprPFfc+nSTBkjqKkDU4FFQ4n3LltuTBs0mS5XOp7V8c=;
X-YMail-OSG: Ucd043oVM1lYsgoW6BuIUjqZRIkaMKleF9Et.x59kTl.9KoAxmcPbhutGiCRV90BcipAsw--
Date: Wed, 10 Oct 2007 12:38:42 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address if the adapter lacks one
To: James.Smart@Emulex.Com, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
In-Reply-To: <470CE78B.2080509@emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <105757.49287.qm@web31805.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- James Smart <James.Smart@Emulex.Com> wrote:
> Here's one pro for setting WWNs at arbitrary times...
>    If the box is migrating applications (say containers) that want
>    different SAN connectivity, where that connectivity (view) is based
>    on their WWN, it would be really nice to selectively set the WWN and
>    not touch the SAN config.

No.  The WWN stays the same and the SAN is re-configured to be
aware of the node migration.  Access patterns could be more
complex than just a single portal allowing access to/from the
SAN from/to the node.

WWN is supposed to be persistent.  This is what it actually is.
It is NOT supposed to be "(auto)generated" and/or changed at a whim.

This also has security implications, and enterprise networks may
refuse to use software (read "kernel") which allows for arbitrary
changes to a node's WWN.

If access to a node is compromised, a rogue agent may change
the node's WWN in order to access SAN zones that it normally
will be denied access to.

    Luben

