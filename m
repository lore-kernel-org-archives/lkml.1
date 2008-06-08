Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYFHURB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYFHURB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYFHUQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:16:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:46224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbYFHUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mKWzB2h8OvO+A8wyWVvq3LUXju2LjXA3CGnKDkZiJj+tc+6s1KugpZF2zn/ePvvZJM
         aKDOE2tIB14o58fbB4Gnievyg0Cg3+Reg6CBUrAkIbuZ/cdjOPQ+ar3aWXc3AFDF09iN
         C9YUhiBQGMHF4WtBDxjA2WxybgwT7CQNKleOs=
Message-ID: <524f69650806081316q219271e1qf33034a2a5463b28@mail.gmail.com>
Date: Sun, 8 Jun 2008 15:16:38 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Q (Igor Mammedov)" <niallain@gmail.com>
Subject: Re: [linux-cifs-client] [PATCH] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Steve French" <sfrench@samba.org>,
       linux-cifs-client@lists.samba.org, stable@kernel.org
In-Reply-To: <71bff3710806080428n18c8e56dwcda54c5c9460d265@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607190055.GA5726@joi>
	 <71bff3710806080428n18c8e56dwcda54c5c9460d265@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not tried this code path recently and mount.cifs should always
be filling in the data field (with at least one mount option) but in a
case where the mount helper is missing, and the UNC name is of the
form //ip_address_of_server/share_name then I would prefer that we
treat this case (no mount options specified) as:
1) userid is \0 (null user)
2) null password
3) server id address comes from the beginning of the UNC name
(required or we fail)
The rest of the parms are at their defaults:
e.g. sec=ntlm  (for smb2 this will be ntlmv2, and perhaps we should
change the default for cifs as well)

On Sun, Jun 8, 2008 at 6:28 AM, Q (Igor Mammedov) <niallain@gmail.com> wrote:
> A quick look trough cifs_mount and cifs_parse_mount_options functions shows
> that mount will fail anyway with error EINVAL when 'data' = NULL.
> May be moving NULL check at the beginning of function will be better
> in this case.
>



-- 
Thanks,

Steve
