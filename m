Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYLPTnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYLPTnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYLPTnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:43:04 -0500
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:47573 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755388AbYLPTnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:43:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=NSC8rpNf+DdyOgQ69WzMpPHagPTieTB+V5NLiZJsGjtTSuMVjQ80FTAeW1310rs718X0DNQhLUklCGvpM9ppVdJEyZ6ujqUGkvRrwdSH00KiKH3zcdodTyhcY+NaueH9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jarkko Lavinen <jlavi@iki.fi>
Subject: Re: i82875p_edac: BAR 0 collision
Date: Tue, 16 Dec 2008 11:39:30 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net,
       Doug Thompson <dougthompson@xmission.com>
References: <20081107114355.GA31730@piipiip.net> <20081111000152.271d9706.akpm@linux-foundation.org> <20081123204459.GA11725@piipiip.net>
In-Reply-To: <20081123204459.GA11725@piipiip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161139.31519.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 23, 2008 12:44 pm Jarkko Lavinen wrote:
> On Tue, Nov 11, 2008 at 12:01:52AM -0800, Andrew Morton wrote:
> > Might be an EDAC driver regression.  It might also be a consequence of
> > PCI address space management fiddlings, but I think most of the changes
> > there post-date 2.6.26?
>
> There were 3 issues:
>  1, PCI resources of the hidden overflow device had to be added separately
>  2. In nodule exit there is one more mci struct kobject put than
>      correspondig gets.
>  3. The edac_mc waitqueue must be stopped before the polled memory
>     area disappears.
>
> Th attached patch fixes these problems. Module loads and removes now
> without problems, with pci, edac, slab and kobject debug options
> enabled.
>
> i82875p code looks so simlar to i82875p that is has likely the same
> ref count issues as i82875p.

It's a little funky for a driver to be calling pci_bus_assign_resources; but 
if it really does act like a bus (sounds like this device does) it might be 
appropriate.  I don't have any problems with the patch, but it's really up to 
Doug.

-- 
Jesse Barnes, Intel Open Source Technology Center

