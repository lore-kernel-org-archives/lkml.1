Return-Path: <linux-kernel-owner+w=401wt.eu-S1030309AbXCLPCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309AbXCLPCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXCLPCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:02:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030309AbXCLPCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VNZhi4sOoClvcoZzjDRyF1H5Uk7ryGBtGZOfSk7G3BPq0pqKM5hsi8bxr+lFwoeX4HCFf9c6mmMjNgYDfexkPA6fYg4NVlAi5mlnld9KKCEwBamol3tiJWciXihp52nc6Mfh+wRsjtp+O28zq5goZCGdjinZKfHM5qiY/oF6Es0=
Message-ID: <45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
Date: Mon, 12 Mar 2007 16:02:11 +0100
From: "=?ISO-8859-1?Q?Llu=EDs_Batlle?=" <viriketo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: bug in select() in linux
In-Reply-To: <20070312160104.25d6b321@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45219fb00703120751t7acd1ae3kb77f556b81a87634@mail.gmail.com>
	 <20070312160104.25d6b321@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, of course you're right. I was inside too much layers to think of
the tcp protocol, and I did not pay attention to it.

Maybe something could be added to the manpage anyway.

The bad thing is that there's no way I can use a socket for writing
using select() if that connection has been half-closed by the other
end. Moo.

Thanks a lot for your time,
Lluís

2007/3/12, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > I've tried a select() for write against a closed tcp socket (closed by
> > the other side), and the select call _blocks_.
>
> A TCP close from the remote node is single sided. It sends a FIN and we
> ACK the FIN, that means only that the remote node has completed *sending*.
>
> > Any write() call to that socket will _not block_, and will return with EPIPE.
>
> We don't know this until you try the write. At that point the other end
> if it has closed entirely will issue an RST and terminate the connection
> in full.
>
> I don't therefore believe that this is actually a bug.
>
> Alan
>
